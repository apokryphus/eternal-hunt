latent function ACS_BehSwitch(prevStateName : name)
{
	var stupidArray 	: array< name >;

	stupidArray.Clear();

	if (ACS_SCAAR_Installed() && ACS_SCAAR_Enabled() && !ACS_E3ARP_Enabled())
	{
		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
			else
			{
				stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
			}
			else
			{
				stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
			}
		}
	}
	else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
	{
		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
			else
			{
				stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
			}
			else
			{
				stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
			}
		}
	}
	else
	{
		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
			}
			else
			{
				stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}
			else
			{
				stupidArray.PushBack( 'igni_primary_beh' );
			}
		}
	}
	
	if ( prevStateName == 'TraverseExploration' || prevStateName == 'PlayerDialogScene' )
	{
		ACS_CombatBehSwitch();
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
			thePlayer.ActivateAndSyncBehaviors(stupidArray);
		}
		else
		{
			ACS_CombatBehSwitch();
		}
	}
}

function ACS_CombatBehSwitch()
{
	var vBehSwitch 										: cBehSwitch;

	if (ACS_New_Replacers_Female_Active())
	{
		return;
	}

	vBehSwitch = new cBehSwitch in theGame;
	
	if (!thePlayer.IsCiri() 
	&& thePlayer.IsAlive()
	)
	{
		if (!thePlayer.IsThrowingItemWithAim()
		&& !thePlayer.IsThrowingItem()
		&& !thePlayer.IsThrowHold()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle())
		{
			vBehSwitch.BehSwitch_Engage();

			if ( !ACS_MS_Enabled() && !ACS_MS_Installed() )
			{
				GetACSWatcher().register_extra_inputs();
			}
			
			if (!thePlayer.IsInCombat())
			{
				GetACSWatcher().HudModuleAutoHideAfterCombat();
				
				GetACSWatcher().RemoveTimer( 'ACS_DelayedSheathSword' );

				//if( !ACS_DisableAutomaticSwordSheathe_Enabled() )
				//{
					//GetACSWatcher().AddTimer( 'ACS_DelayedSheathSword', 2.f, false );
				//}

				if (thePlayer.HasTag ('summoned_shades'))
				{
					thePlayer.RemoveTag('summoned_shades');
				}
				
				if (thePlayer.HasTag ('ethereal_shout'))
				{
					thePlayer.RemoveTag('ethereal_shout');
				}
				
				/*
				if (thePlayer.HasTag ('vampire_claws_equipped'))
				{
					ClawDestroy();

					thePlayer.PlayEffectSingle('claws_effect');
					thePlayer.StopEffect('claws_effect');
				}
				*/

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

				HybridTagRemoval();

				ACS_Axii_Shield_Destroy_IMMEDIATE();

				ACS_Shield_Destroy();

				ACS_ThingsThatShouldBeRemoved();

				ACS_RemoveStabbedEntities();

				Bruxa_Camo_Decoy_Deactivate();

				GetACSTentacle_1().Destroy();

				GetACSTentacle_2().Destroy();

				GetACSTentacle_3().Destroy();

				GetACSTentacleAnchor().Destroy();

				GetACSWatcher().SetRageProcess(false);

				//thePlayer.RemoveTag('ACS_Has_Summoned_Nekker_Guardian');
				
				//GetACSWatcher().AddTimer('ACS_DetachBehaviorTimer', 2, false);

				IgniBowDestroy();
				AxiiBowDestroy();
				AardBowDestroy();
				YrdenBowDestroy();
				QuenBowDestroy();

				//ACS_NekkerGuardianShareLifeForce_Destroy();

				thePlayer.ClearAnimationSpeedMultipliers();
				
				GetACSWatcher().RemoveTimer('AdditionalSpawnsDelay');

				GetACSWatcher().AddTimer('AdditionalSpawnsDelay', RandRange(30, 10), false);
			}
			else
			{
				GetACSWatcher().RemoveTimer( 'ACS_DelayedSheathSword' );

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
}

function ACS_Forest_God_Spawn_Controller()
{
	if (ACS_ShadowsSpawnChancesNormal() != 0
	&& !theGame.IsDialogOrCutscenePlaying() 
	&& !thePlayer.IsInNonGameplayCutscene() 
	&& !thePlayer.IsInGameplayScene()
	&& !ACS_PlayerSettlementCheck(50)
	&& !ACS_GetHostilesCheck()
	&& !thePlayer.IsInInterior()
	&& thePlayer.IsOnGround()
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
			if( RandF() < ACS_ShadowsSpawnChancesNormal() * ACS_ShadowsSpawnChancesNormal() ) 
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
			if( RandF() < ACS_ShadowsSpawnChancesNormal() ) 
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
	if( RandF() < ACS_WildHuntSpawnChancesNormal() 
	&& !ACS_GetHostilesCheck()
	&& !theGame.IsDialogOrCutscenePlaying() 
	&& !thePlayer.IsInNonGameplayCutscene() 
	&& !thePlayer.IsInGameplayScene()
	&& !ACS_PlayerSettlementCheck(50)
	&& !thePlayer.IsInInterior()
	&& thePlayer.IsOnGround()
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
	if( RandF() < ACS_NightStalkerSpawnChancesNormal() 
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
	if( RandF() < ACS_ElderbloodAssassinSpawnChancesNormal() 
	&& !theGame.IsDialogOrCutscenePlaying() 
	&& !thePlayer.IsInNonGameplayCutscene() 
	&& !thePlayer.IsInGameplayScene()
	&& !ACS_PlayerSettlementCheck(50)
	&& thePlayer.IsOnGround()
	&& !thePlayer.IsInInterior()
	&& !ACS_GetHostilesCheck()
	)
	{
		if (ACS_can_spawn_elderblood_assassin())
		{
			ACS_refresh_elderblood_assassin_spawn_cooldown();

			GetACSWatcher().ACS_SpawnElderbloodAssassin();
		}
	}
}

function ACS_ExplorationBehSwitch()
{
	var vBehSwitch : cBehSwitch;
	vBehSwitch = new cBehSwitch in theGame;
	
	if (!thePlayer.IsCiri() 
	&& thePlayer.IsAlive())
	{
		vBehSwitch.BehSwitch_Engage_3();
	}
}

function ACS_BehSwitchINIT()
{
	var vBehSwitch : cBehSwitch;

	if (ACS_New_Replacers_Female_Active() && !thePlayer.IsCiri())
	{
		return;
	}

	vBehSwitch = new cBehSwitch in theGame;
	
	if (ACS_Enabled())
	{
		if (!thePlayer.IsCiri()
		&& !theGame.IsDialogOrCutscenePlaying() 
		&& !thePlayer.IsInNonGameplayCutscene() 
		&& !thePlayer.IsInGameplayScene()
		&& !thePlayer.IsSwimming()
		&& !thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		&& thePlayer.IsAlive()
		)
		{
			vBehSwitch.BehSwitch_Engage_2();
			//UpdateBehGraph();
		}
	}
}

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
		if (ACS_SCAAR_Installed() && ACS_SCAAR_Enabled() && !ACS_E3ARP_Enabled())
		{
			BehSwitch_SCAAR_3();
		}
		else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
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

		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP_swordwalk' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	entry function BehSwitch_SCAAR_3()
	{
		stupidArray.Clear();

		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR_swordwalk' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	entry function BehSwitch_3()
	{
		stupidArray.Clear();

		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_swordwalk_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_swordwalk' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
				}
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
		}

		thePlayer.ActivateBehaviors(stupidArray);
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
		
		if ( thePlayer.HasTag('vampire_claws_equipped') )
		{
			thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
			thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
		}
		else
		{
			thePlayer.SetBehaviorVariable( 'playerWeapon', (int) weapontype );
			thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) weapontype );
		}
		
		if ( thePlayer.IsUsingHorse() )
		{
			thePlayer.SetBehaviorVariable( 'isOnHorse', 1.0 );
		}
		else
		{
			thePlayer.SetBehaviorVariable( 'isOnHorse', 0.0 );
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
		ACS_WeaponDestroyInit();

		HybridTagRemoval();

		if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
		{
			thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
		}

		ACS_Load_Sound();

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
			if ( ACS_GetHybridModeLightAttack() == 0 )
			{
				if (!thePlayer.HasTag('HybridDefaultWeaponTicket')){thePlayer.AddTag('HybridDefaultWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 1 )
			{
				if (!thePlayer.HasTag('HybridOlgierdWeaponTicket')){thePlayer.AddTag('HybridOlgierdWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 2 )
			{
				if (!thePlayer.HasTag('HybridEredinWeaponTicket')){thePlayer.AddTag('HybridEredinWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 3 )
			{
				if (!thePlayer.HasTag('HybridClawWeaponTicket')){thePlayer.AddTag('HybridClawWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 4 )
			{
				if (!thePlayer.HasTag('HybridImlerithWeaponTicket')){thePlayer.AddTag('HybridImlerithWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 5 )
			{
				if (!thePlayer.HasTag('HybridSpearWeaponTicket')){thePlayer.AddTag('HybridSpearWeaponTicket');}

				GetACSWatcher().SecondaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 6 )
			{
				if (!thePlayer.HasTag('HybridGregWeaponTicket')){thePlayer.AddTag('HybridGregWeaponTicket');}

				GetACSWatcher().SecondaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 7 )
			{
				if (!thePlayer.HasTag('HybridAxeWeaponTicket')){thePlayer.AddTag('HybridAxeWeaponTicket');}

				GetACSWatcher().SecondaryWeaponSwitch();
			}
			else if ( ACS_GetHybridModeLightAttack() == 8 )
			{
				if (!thePlayer.HasTag('HybridGiantWeaponTicket')){thePlayer.AddTag('HybridGiantWeaponTicket');}

				GetACSWatcher().SecondaryWeaponSwitch();
			}
		}
		else if (ACS_GetWeaponMode() == 3 )
		{
			ACS_DefaultSwitch();
		} 

		if (ACS_SCAAR_Installed() && ACS_SCAAR_Enabled() && !ACS_E3ARP_Enabled())
		{
			ActivateBehaviors_SCAAR_Default();
		}
		else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
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

		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP_swordwalk' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_SCAAR_Default()
	{
		stupidArray.Clear();

		if (ACS_SwordWalk_Enabled())
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR_swordwalk' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
		}
		else
		{
			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_Default()
	{
		if (ACS_SwordWalk_Enabled())
		{
			stupidArray.Clear();

			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_swordwalk_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_swordwalk' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
				}
			}

			thePlayer.ActivateBehaviors(stupidArray);
		}
		else
		{
			stupidArray.Clear();

			if (ACS_PassiveTaunt_Enabled())
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else
			{
				if (thePlayer.HasTag('quen_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_primary_beh' );
				}
				else if (thePlayer.HasTag('axii_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_primary_beh' );
				}
				else if (thePlayer.HasTag('aard_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_primary_beh' );
				}
				else if (thePlayer.HasTag('yrden_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_primary_beh' );
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'quen_secondary_beh' );
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'axii_secondary_beh' );
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'aard_secondary_beh' );
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'yrden_secondary_beh' );
				}
				else if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					stupidArray.PushBack( 'claw_beh' );
				}
				else if (thePlayer.HasTag('igni_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_primary_beh' );
				}
				else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
				{
					stupidArray.PushBack( 'igni_secondary_beh' );
				}
				else
				{
					stupidArray.PushBack( 'igni_primary_beh' );
				}
			}

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
		
		if ( thePlayer.HasTag('vampire_claws_equipped') )
		{
			thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
			thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
		}
		else
		{
			thePlayer.SetBehaviorVariable( 'playerWeapon', (int) weapontype );
			thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) weapontype );
		}
		
		if ( thePlayer.IsUsingHorse() )
		{
			thePlayer.SetBehaviorVariable( 'isOnHorse', 1.0 );
		}
		else
		{
			thePlayer.SetBehaviorVariable( 'isOnHorse', 0.0 );
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
		if (ACS_SCAAR_Installed() && ACS_SCAAR_Enabled() && !ACS_E3ARP_Enabled())
		{
			if ( ACS_SwordWalk_Enabled() )
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt();
				}
				else
				{
					BehSwitchPrime_SCAAR_SwordWalk();
				}
			}
			else
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					BehSwitchPrime_SCAAR_Passive_Taunt();
				}
				else
				{
					BehSwitchPrime_SCAAR();
				}
			}
		}
		else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
		{
			if ( ACS_SwordWalk_Enabled() )
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt();
				}
				else
				{
					BehSwitchPrime_E3ARP_SwordWalk();
				}
			}
			else
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					BehSwitchPrime_E3ARP_Passive_Taunt();
				}
				else
				{
					BehSwitchPrime_E3ARP();
				}
			}
		}
		else
		{
			if ( ACS_SwordWalk_Enabled() )
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					BehSwitchPrime_SwordWalk_Passive_Taunt();
				}
				else
				{
					BehSwitchPrime_SwordWalk();
				}
			}
			else
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					BehSwitchPrime_Passive_Taunt();
				}
				else
				{
					BehSwitchPrime();
				}
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
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
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
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
						}
					}
				}
			}
			else
			{
				if 
				(
					thePlayer.HasTag('vampire_claws_equipped')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
					{
						thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
					{
						thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
					}
				}
			}
			
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
			}
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
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_Passive_Taunt_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
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
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
						}
					}
				}
			}
			else
			{
				if 
				(
					thePlayer.HasTag('vampire_claws_equipped')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
					{
						thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
					{
						thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk()
	{
		ActivateBehaviors_SwordWalk();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_SwordWalk_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_SwordWalk_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_SwordWalk_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_SwordWalk_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SwordWalk_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
						}
					}
				}
			}
			else 
			{
				if 
				(
					thePlayer.HasTag('vampire_claws_equipped')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
					{
						thePlayer.ActivateAndSyncBehavior( 'claw_beh' );
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
					{
						thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt()
	{
		ActivateBehaviors_SwordWalk_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_SwordWalk_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_SwordWalk_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_SwordWalk_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SwordWalk_Passive_Taunt_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
						}
					}
				}
			}
			else 
			{
				if 
				(
					thePlayer.HasTag('vampire_claws_equipped')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
					{
						thePlayer.ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
					{
						thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function ActivateBehaviors()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh' );
		}
		else if (thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh' );
		}
		else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh' );
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_Passive_Taunt()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh' );
		}
		else if (thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_SwordWalk()
	{
		stupidArray.Clear();
		
		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh' );
		}
		else if (thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
		}
		else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_swordwalk' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_SwordWalk_Passive_Taunt()
	{
		stupidArray.Clear();
		
		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh' );
		}
		else if (thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_swordwalk_passive_taunt' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function ActivateBehaviors_SCAAR()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_SCAAR' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
		}
		else if (
		thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
		}
		else if (
		thePlayer.HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_SCAAR_Passive_Taunt()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_SCAAR_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
		}
		else if (
		thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_SCAAR_SwordWalk()
	{
		stupidArray.Clear();
		
		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_SCAAR_swordwalk' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_SCAAR_swordwalk' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_SCAAR_swordwalk' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_SCAAR_swordwalk' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_SCAAR_swordwalk' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_SCAAR_swordwalk' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_swordwalk' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_SCAAR' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
		}
		else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_SCAAR_swordwalk' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_SCAAR_SwordWalk_Passive_Taunt()
	{
		stupidArray.Clear();
		
		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_SCAAR_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
		}

		thePlayer.ActivateBehaviors(stupidArray);
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
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
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
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
						}
					}
				}
			}
			else
			{
				if 
				(
					thePlayer.HasTag('vampire_claws_equipped')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
					{
						thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
					{
						thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk()
	{
		ActivateBehaviors_SCAAR_SwordWalk();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_SCAAR_SwordWalk_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_SCAAR_SwordWalk_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_SCAAR_SwordWalk_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
						}
					}
				}
			}
			else 
			{
				if 
				(
					thePlayer.HasTag('vampire_claws_equipped')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
					{
						thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
					{
						thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
			}
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
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR_passive_taunt' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR_passive_taunt' );
				}
			}
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
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
						}
					}
				}
			}
			else
			{
				if 
				(
					thePlayer.HasTag('vampire_claws_equipped')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR_passive_taunt' )
					{
						thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR_passive_taunt' );
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
					{
						thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt()
	{
		ActivateBehaviors_SCAAR_SwordWalk_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
		}
	}

	latent function BehSwitchPrime_SCAAR_SwordWalk_Passive_Taunt_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
				}
			}
			else 
			{
				if 
				(
					thePlayer.HasTag('vampire_claws_equipped')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_SCAAR' )
					{
						thePlayer.ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
					{
						thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
					}
				}
			}
			
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function ActivateBehaviors_E3ARP()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_E3ARP' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
		}
		else if (
		thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
		}
		else if (
		thePlayer.HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_E3ARP_Passive_Taunt()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_E3ARP_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
		}
		else if (
		thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_E3ARP_SwordWalk()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_E3ARP_swordwalk' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_E3ARP_swordwalk' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_E3ARP_swordwalk' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_E3ARP_swordwalk' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_E3ARP_swordwalk' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_E3ARP_swordwalk' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_swordwalk' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_E3ARP' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
		}
		else if (
		thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
		}
		else if (
		thePlayer.HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_E3ARP_swordwalk' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
		}

		thePlayer.ActivateBehaviors(stupidArray);
	}

	latent function ActivateBehaviors_E3ARP_SwordWalk_Passive_Taunt()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			stupidArray.PushBack( 'claw_beh_E3ARP_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('igni_bow_equipped')
		|| thePlayer.HasTag('axii_bow_equipped')
		|| thePlayer.HasTag('aard_bow_equipped')
		|| thePlayer.HasTag('yrden_bow_equipped')
		|| thePlayer.HasTag('quen_bow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
		}
		else if (
		thePlayer.HasTag('igni_crossbow_equipped')
		|| thePlayer.HasTag('axii_crossbow_equipped')
		|| thePlayer.HasTag('aard_crossbow_equipped')
		|| thePlayer.HasTag('yrden_crossbow_equipped')
		|| thePlayer.HasTag('quen_crossbow_equipped')
		)
		{
			stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
		}
		else if (
		thePlayer.HasTag('igni_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('igni_secondary_sword_equipped'))
		{
			stupidArray.PushBack( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
		}
		else
		{
			stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
		}

		thePlayer.ActivateBehaviors(stupidArray);
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
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
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
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
						}
					}
				}
			}
			else
			{
				if 
				(
					thePlayer.HasTag('vampire_claws_equipped')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
					{
						thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
					{
						thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk()
	{
		ActivateBehaviors_E3ARP_SwordWalk();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_E3ARP_SwordWalk_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_E3ARP_SwordWalk_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_E3ARP_SwordWalk_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
						}
					}
				}
			}
			else 
			{
				if 
				(
					thePlayer.HasTag('vampire_claws_equipped')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
					{
						thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
					{
						thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
			}
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
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP_passive_taunt' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP_passive_taunt' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP_passive_taunt' );
				}
			}
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
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
						}
					}
				}
			}
			else
			{
				if 
				(
					thePlayer.HasTag('vampire_claws_equipped')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP_passive_taunt' )
					{
						thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP_passive_taunt' );
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
					{
						thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
					}
				}
			} 
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt()
	{
		ActivateBehaviors_E3ARP_SwordWalk_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
		{
			if (thePlayer.HasTag('igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('igni_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('igni_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('quen_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('quen_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
		{
			if (thePlayer.HasTag('axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('axii_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('axii_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('aard_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('aard_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
		else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
		{
			if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('yrden_bow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('yrden_crossbow_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_FocusMode()
	{
		if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}	
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('igni_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('axii_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('aard_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			ACS_GetFocusModeSilverWeapon() == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('quen_secondary_sword_equipped') 
			|| ACS_GetFocusModeSteelWeapon() == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' ); ACS_Theft_Prevention_9 ();
			}
		}
			
		else if 
		(
			thePlayer.HasTag('yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				ACS_Theft_Prevention_9 (); thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_GetFistMode() == 0
			|| ACS_GetFistMode() == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
				{
					thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
				}
			}
			else if (ACS_GetFistMode() == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
				{
					thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
		}
	}

	latent function BehSwitchPrime_E3ARP_SwordWalk_Passive_Taunt_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Steel() && thePlayer.HasTag('yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
				}
			}
			else
			{
				if 
				(
					thePlayer.HasTag('vampire_claws_equipped')
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_E3ARP' )
					{
						thePlayer.ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
					{
						thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
					}
				}
			} 
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
			{
				thePlayer.ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
			}
		}
	}
}